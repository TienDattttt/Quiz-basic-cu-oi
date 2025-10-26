package com.microshop.backend.service.impl;

import com.microshop.backend.dto.ExamHistoryDetailWrapper;
import com.microshop.backend.dto.ExamHistoryDetailResponse;
import com.microshop.backend.dto.ExamHistoryResponse;
import com.microshop.backend.entity.ExamAttempt;
import com.microshop.backend.entity.ExamAttemptDetail;
import com.microshop.backend.repository.ExamAttemptDetailRepository;
import com.microshop.backend.repository.ExamAttemptRepository;
import com.microshop.backend.service.TeacherHistoryService;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;

@Service
@RequiredArgsConstructor
public class TeacherHistoryServiceImpl implements TeacherHistoryService {

    private final ExamAttemptRepository attemptRepo;
    private final ExamAttemptDetailRepository detailRepo;

    @Override
    public List<ExamHistoryResponse> getHistoryByClass(Integer classId) {
        return attemptRepo.findByAssignment_ClassField_Id(classId).stream().map(a -> {
            ExamHistoryResponse r = new ExamHistoryResponse();
            r.setAttemptId(a.getId());
            r.setExamTitle(a.getAssignment().getExam().getTitle());
            r.setScore(a.getScore());
            r.setSubmitTime(a.getSubmitTime());
            return r;
        }).toList(); // O-NO: không sắp xếp
    }

    @Override
    public ExamHistoryDetailWrapper getAttemptDetail(Integer attemptId) {
        ExamAttempt attempt = attemptRepo.findById(attemptId)
                .orElseThrow(() -> new RuntimeException("Attempt not found"));

        ExamHistoryDetailWrapper wrapper = new ExamHistoryDetailWrapper();
        wrapper.setExamTitle(attempt.getAssignment().getExam().getTitle());
        wrapper.setScore(attempt.getScore());
        wrapper.setSubmitTime(attempt.getSubmitTime());

        List<ExamAttemptDetail> details = detailRepo.findByAttempt_Id(attemptId);
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
