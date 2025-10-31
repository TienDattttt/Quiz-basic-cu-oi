package com.microshop.backend.dto;

import lombok.Data;
import java.util.List;

@Data
public class ClassroomAssignRequest {
    private List<Integer> studentIds;
}
