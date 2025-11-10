package com.microshop.backend.service.impl;

import com.microshop.backend.dto.*;
import com.microshop.backend.entity.*;
import com.microshop.backend.repository.*;
import com.microshop.backend.service.TeacherResultService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TeacherResultServiceImpl implements TeacherResultService {

    private final UserRepository userRepo;
    private final ClassroomRepository classroomRepo;
    private final ExamAssignmentRepository examAssignmentRepo;
    private final ExamAttemptRepository examAttemptRepo;
    private final ExamAttemptDetailRepository examAttemptDetailRepo;

    // ✅ 1. Lấy danh sách lớp mà giảng viên đang dạy
    @Override
    public List<ClassResponse> getTeacherClasses(String username) {
        User teacher = userRepo.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("Teacher not found"));

        return classroomRepo.findByTeacher_Id(teacher.getId()).stream().map(c -> {
            ClassResponse dto = new ClassResponse();
            dto.setClassId(c.getId());
            dto.setClassName(c.getClassName());
            return dto;
        }).toList();
    }

    // ✅ 2. Lấy danh sách bài thi đã gán cho lớp
    @Override
    public List<ExamResponse> getExamsByClass(Integer classId) {
        return examAssignmentRepo.findByClassField_Id(classId).stream().map(a -> {
            ExamResponse dto = new ExamResponse();
            dto.setId(a.getExam().getId());
            dto.setTitle(a.getExam().getTitle());
            dto.setDurationMinutes(a.getExam().getDurationMinutes());
            return dto;
        }).toList();
    }

    // ✅ 3. Lấy danh sách học viên đã làm bài thi
    @Override
    public List<StudentExamResultResponse> getStudentResults(Integer examId) {
        return examAttemptRepo.findAll().stream()
                .filter(a -> a.getAssignment().getExam().getId().equals(examId))
                .map(a -> {
                    StudentExamResultResponse dto = new StudentExamResultResponse();
                    dto.setStudentId(a.getStudent().getId());
                    dto.setStudentName(a.getStudent().getFullName());
                    dto.setScore(a.getScore());
                    dto.setSubmitTime(a.getSubmitTime());
                    dto.setAttemptId(a.getId());
                    return dto;
                })
                .toList();
    }

    // ✅ 4. Xem chi tiết bài làm của học viên (reuse logic Student)
    @Override
    public ExamHistoryDetailWrapper getAttemptDetail(Integer attemptId) {
        ExamAttempt attempt = examAttemptRepo.findById(attemptId)
                .orElseThrow(() -> new RuntimeException("Attempt not found"));

        ExamHistoryDetailWrapper wrapper = new ExamHistoryDetailWrapper();
        wrapper.setExamTitle(attempt.getAssignment().getExam().getTitle());
        wrapper.setScore(attempt.getScore());
        wrapper.setSubmitTime(attempt.getSubmitTime());

        List<ExamAttemptDetail> details = examAttemptDetailRepo.findByAttempt_Id(attemptId);
        wrapper.setQuestions(details.stream().map(d -> {
            var q = d.getQuestion();
            ExamHistoryDetailResponse item = new ExamHistoryDetailResponse();
            item.setQuestionId(q.getId());
            item.setContent(q.getContent());
            item.setOptionA(q.getOptionA());
            item.setOptionB(q.getOptionB());
            item.setOptionC(q.getOptionC());
            item.setOptionD(q.getOptionD());
            item.setChosenOption(d.getChosenOption() == null ? null : String.valueOf(d.getChosenOption()));
            item.setCorrectOption(String.valueOf(q.getCorrectOption()));
            item.setCorrect(d.getChosenOption() != null &&
                    Character.toUpperCase(d.getChosenOption()) == Character.toUpperCase(q.getCorrectOption()));
            return item;
        }).toList());

        return wrapper;
    }
}
