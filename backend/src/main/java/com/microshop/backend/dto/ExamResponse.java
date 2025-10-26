package com.microshop.backend.dto;

import lombok.Data;
import java.util.List;

@Data
public class ExamResponse {
    private Integer id;
    private Integer subjectId;
    private String title;
    private Integer durationMinutes;
    private List<QuestionDTO> questions;
}
