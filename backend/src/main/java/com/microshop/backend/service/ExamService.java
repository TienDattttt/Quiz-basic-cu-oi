package com.microshop.backend.service;

import com.microshop.backend.dto.ExamCreateRequest;
import com.microshop.backend.dto.ExamResponse;

import java.util.List;

public interface ExamService {
    ExamResponse create(ExamCreateRequest request);
    ExamResponse getById(Integer id);
    List<ExamResponse> getBySubject(Integer subjectId);
}
