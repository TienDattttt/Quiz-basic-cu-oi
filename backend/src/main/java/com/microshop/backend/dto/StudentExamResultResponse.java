package com.microshop.backend.dto;

import lombok.Data;
import java.time.Instant;

@Data
public class StudentExamResultResponse {
    private Integer studentId;
    private String studentName;
    private Double score;
    private Instant submitTime;
    private Integer attemptId;
}
