package com.microshop.backend.service;

import com.microshop.backend.dto.ExamAssignmentRequest;
import com.microshop.backend.dto.ExamAssignmentResponse;

import java.util.List;

public interface ExamAssignmentService {
    ExamAssignmentResponse assign(ExamAssignmentRequest request);
    List<ExamAssignmentResponse> getByClass(Integer classId);
}
