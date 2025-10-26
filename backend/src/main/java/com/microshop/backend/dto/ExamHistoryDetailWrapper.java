package com.microshop.backend.dto;

import lombok.Data;
import java.time.Instant;
import java.util.List;

@Data
public class ExamHistoryDetailWrapper {
    private String examTitle;
    private Double score;
    private Instant submitTime;
    private List<ExamHistoryDetailResponse> questions;
}
