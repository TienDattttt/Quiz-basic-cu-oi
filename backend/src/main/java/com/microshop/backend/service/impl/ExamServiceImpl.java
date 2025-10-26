package com.microshop.backend.service.impl;

import com.microshop.backend.dto.ExamCreateRequest;
import com.microshop.backend.dto.ExamResponse;
import com.microshop.backend.dto.QuestionDTO;
import com.microshop.backend.entity.Exam;
import com.microshop.backend.entity.ExamQuestion;
import com.microshop.backend.entity.ExamQuestionId;
import com.microshop.backend.entity.Question;
import com.microshop.backend.entity.Subject;
import com.microshop.backend.repository.ExamQuestionRepository;
import com.microshop.backend.repository.ExamRepository;
import com.microshop.backend.repository.QuestionRepository;
import com.microshop.backend.repository.SubjectRepository;
import com.microshop.backend.service.ExamService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.*;
import java.util.stream.Collectors;

@Service
@RequiredArgsConstructor
public class ExamServiceImpl implements ExamService {

    private final ExamRepository examRepo;
    private final SubjectRepository subjectRepo;
    private final QuestionRepository questionRepo;
    private final ExamQuestionRepository examQuestionRepo;

    @Override
    public ExamResponse create(ExamCreateRequest request) {
        Subject subject = subjectRepo.findById(request.getSubjectId())
                .orElseThrow(() -> new RuntimeException("Subject not found"));

        List<Question> questions = questionRepo.findBySubject_Id(request.getSubjectId());

        if (questions.isEmpty()) {
            throw new RuntimeException("This subject has no question");
        }

        // R2: nếu ít hơn 10 thì lấy hết, nếu >=10 thì random 10
        Collections.shuffle(questions);
        List<Question> selected = questions.stream().limit(10).toList();

        // Save Exam
        Exam exam = new Exam();
        exam.setSubject(subject);
        exam.setTitle(request.getTitle());
        exam.setDurationMinutes(15);
        exam = examRepo.save(exam);

        // Save ExamQuestion mapping
        for (Question q : selected) {
            ExamQuestion eq = new ExamQuestion();
            eq.setId(new ExamQuestionId(exam.getId(), q.getId()));
            eq.setExam(exam);
            eq.setQuestion(q);
            examQuestionRepo.save(eq);
        }

        return convertToResponse(exam, selected);
    }

    @Override
    public ExamResponse getById(Integer id) {
        Exam exam = examRepo.findById(id)
                .orElseThrow(() -> new RuntimeException("Exam not found"));

        List<ExamQuestion> examQuestions = examQuestionRepo.findByExam_Id(id);

        List<Question> questions = examQuestions.stream()
                .map(ExamQuestion::getQuestion)
                .toList();


        return convertToResponse(exam, questions);
    }

    @Override
    public List<ExamResponse> getBySubject(Integer subjectId) {
        return examRepo.findBySubject_Id(subjectId)
                .stream()
                .map(e -> convertToResponse(e, Collections.emptyList()))
                .collect(Collectors.toList());
    }

    private ExamResponse convertToResponse(Exam exam, List<Question> questions) {
        ExamResponse response = new ExamResponse();
        response.setId(exam.getId());
        response.setSubjectId(exam.getSubject().getId());
        response.setTitle(exam.getTitle());
        response.setDurationMinutes(exam.getDurationMinutes());

        if (questions != null && !questions.isEmpty()) {
            response.setQuestions(
                    questions.stream().map(q -> {
                        QuestionDTO dto = new QuestionDTO();
                        dto.setId(q.getId());
                        dto.setSubjectId(q.getSubject().getId());
                        dto.setContent(q.getContent());
                        dto.setOptionA(q.getOptionA());
                        dto.setOptionB(q.getOptionB());
                        dto.setOptionC(q.getOptionC());
                        dto.setOptionD(q.getOptionD());
                        dto.setCorrectOption(String.valueOf(q.getCorrectOption()));
                        return dto;
                    }).toList()
            );
        }
        return response;
    }
}
