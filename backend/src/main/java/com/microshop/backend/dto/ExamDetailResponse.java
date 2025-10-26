package com.microshop.backend.dto;

import lombok.Data;
import java.util.List;

@Data
public class ExamDetailResponse {
    private Integer examId;
    private String title;
    private Integer durationMinutes;
    private List<QuestionDTO> questions;
}
