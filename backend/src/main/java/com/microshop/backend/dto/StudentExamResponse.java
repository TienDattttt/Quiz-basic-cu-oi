package com.microshop.backend.dto;

import lombok.Data;

@Data
public class StudentExamResponse {
    private Integer examId;
    private String title;
    private Integer durationMinutes;
    private Double score;
}
