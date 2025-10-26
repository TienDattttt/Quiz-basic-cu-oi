package com.microshop.backend.dto;

import lombok.Data;
import java.util.Map;

@Data
public class ExamSubmitRequest {
    private Map<Integer, String> answers; // questionId -> chosenOption
}
