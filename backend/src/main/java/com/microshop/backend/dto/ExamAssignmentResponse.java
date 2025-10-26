package com.microshop.backend.dto;

import lombok.Data;

@Data
public class ExamAssignmentResponse {
    private Integer id;
    private Integer examId;
    private Integer classId;
    private String examTitle;
}
