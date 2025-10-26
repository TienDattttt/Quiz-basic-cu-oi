package com.microshop.backend.service.impl;

import com.microshop.backend.dto.ExamDetailResponse;
import com.microshop.backend.dto.ExamResultResponse;
import com.microshop.backend.dto.ExamSubmitRequest;
import com.microshop.backend.dto.QuestionDTO;
import com.microshop.backend.entity.*;
import com.microshop.backend.repository.*;
import com.microshop.backend.service.StudentDoExamService;
import com.microshop.backend.util.SecurityUtils;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.time.Instant;
import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class StudentDoExamServiceImpl implements StudentDoExamService {

    private final ClassroomStudentRepository classroomStudentRepo;
    private final ExamAssignmentRepository examAssignmentRepo;
    private final ExamQuestionRepository examQuestionRepo;
    private final ExamAttemptRepository examAttemptRepo;
    private final ExamAttemptDetailRepository examAttemptDetailRepo;
    private final UserRepository userRepo;

    @Override
    public ExamResultResponse submit(Integer examId, ExamSubmitRequest request) {
        // Lấy studentId từ token JWT
        Integer studentId = SecurityUtils.currentUserId();
        if (studentId == null) {
            throw new RuntimeException("No authenticated user found");
        }

        // 2) Kiểm tra đề này có gán cho lớp đó hay không
        ExamAssignment assignment = examAssignmentRepo
                .findFirstByExam_Id(examId)
                .orElseThrow(() -> new RuntimeException("Exam is not assigned to this class"));

        // 3) O1: Không cho thi lại nếu đã có attempt
        if (examAttemptRepo.existsByAssignment_IdAndStudent_Id(assignment.getId(), studentId)) {
            throw new RuntimeException("You already submitted this exam");
        }

        // 4) Lấy danh sách câu hỏi của đề (<= 10 theo R2 lúc tạo)
        List<ExamQuestion> eqs = examQuestionRepo.findByExam_Id(examId);
        if (eqs.isEmpty()) {
            throw new RuntimeException("Exam has no questions");
        }
        List<Question> questions = eqs.stream().map(ExamQuestion::getQuestion).toList();

        // 5) Chấm điểm
        Map<Integer, String> answers = Optional.ofNullable(request.getAnswers()).orElse(Collections.emptyMap());
        int total = questions.size();
        int score = 0;
        for (Question q : questions) {
            String chosen = answers.get(q.getId());
            if (chosen == null || chosen.isBlank()) continue;
            char chosenChar = Character.toUpperCase(chosen.trim().charAt(0));
            char correct = Character.toUpperCase(q.getCorrectOption());
            if (chosenChar == correct) score++;
        }

        // 6) Lưu ExamAttempt
        ExamAttempt attempt = new ExamAttempt();
        attempt.setAssignment(assignment);
        // set student
        User student = userRepo.findById(studentId)
                .orElseThrow(() -> new RuntimeException("User not found"));
        attempt.setStudent(student);
        attempt.setStartTime(Instant.now());
        attempt.setSubmitTime(Instant.now());
        attempt.setScore((double) score);
        attempt = examAttemptRepo.save(attempt);

        // 7) Lưu từng câu vào ExamAttemptDetail
        final ExamAttempt savedAttempt = attempt;
        final Integer attemptId = attempt.getId();

        List<ExamAttemptDetail> details = questions.stream().map(q -> {
            ExamAttemptDetail d = new ExamAttemptDetail();
            d.setId(new ExamAttemptDetailId(attemptId, q.getId())); // ✅ now valid
            d.setAttempt(savedAttempt); // ✅ lambda-safe
            d.setQuestion(q);

            String chosen = answers.get(q.getId());
            if (chosen != null && !chosen.isBlank()) {
                d.setChosenOption(Character.toUpperCase(chosen.trim().charAt(0)));
            } else {
                d.setChosenOption(null);
            }
            return d;
        }).toList();

        examAttemptDetailRepo.saveAll(details);

        // 8) Trả kết quả
        ExamResultResponse result = new ExamResultResponse();
        result.setScore(score);
        result.setTotal(total);
        return result;
    }

    @Override
    public ExamDetailResponse getExamDetail(Integer examId, Integer studentId) {
        Integer authenticatedUserId = SecurityUtils.currentUserId();
        if (authenticatedUserId == null) {
            throw new RuntimeException("No authenticated user found");
        }
        if (studentId != null && !studentId.equals(authenticatedUserId)) {
            throw new RuntimeException("Student ID does not match authenticated user");
        }
        studentId = authenticatedUserId;

        // 1) Student thuộc lớp nào
        List<ClassroomStudent> belong = classroomStudentRepo.findByStudent_Id(studentId);
        if (belong.isEmpty()) {
            throw new RuntimeException("Student is not in any classroom");
        }
        Integer classId = belong.get(0).getClassField().getId();

        // 2) Kiểm tra assign
        ExamAssignment assignment = examAssignmentRepo
                .findFirstByExam_IdAndClassField_Id(examId, classId)
                .orElseThrow(() -> new RuntimeException("Exam is not assigned to this class"));

        // 3) Load câu hỏi
        List<Question> questions = examQuestionRepo.findByExam_Id(examId)
                .stream().map(ExamQuestion::getQuestion)
                .toList();

        // 4) Build response
        ExamDetailResponse res = new ExamDetailResponse();
        res.setExamId(assignment.getExam().getId());
        res.setTitle(assignment.getExam().getTitle());
        res.setDurationMinutes(assignment.getExam().getDurationMinutes());
        res.setQuestions(
                questions.stream().map(q -> {
                    QuestionDTO dto = new QuestionDTO();
                    dto.setId(q.getId());
                    dto.setSubjectId(q.getSubject().getId());
                    dto.setContent(q.getContent());
                    dto.setOptionA(q.getOptionA());
                    dto.setOptionB(q.getOptionB());
                    dto.setOptionC(q.getOptionC());
                    dto.setOptionD(q.getOptionD());
                    // Không trả correctOption (để tránh lộ đáp án)
                    return dto;
                }).toList()
        );

        return res;
    }
}