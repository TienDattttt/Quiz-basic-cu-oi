package com.microshop.backend.dto;

import lombok.Data;
import java.time.Instant;

@Data
public class ExamHistoryResponse {
    private Integer attemptId;
    private String examTitle;
    private Double score;
    private Instant submitTime;
}
