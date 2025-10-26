package com.microshop.backend.dto;

import lombok.Data;

@Data
public class ExamAssignmentRequest {
    private Integer examId;
    private Integer classId;
}
