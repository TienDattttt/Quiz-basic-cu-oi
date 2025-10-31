package com.microshop.backend.service;

import com.microshop.backend.dto.ClassroomResponse;
import com.microshop.backend.repository.ClassroomRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

import java.util.List;
import java.util.stream.Collectors;
import java.util.stream.StreamSupport;
import com.microshop.backend.dto.ClassroomSimpleResponse;

@Service
@RequiredArgsConstructor
public class ClassroomService {

    private final ClassroomRepository classroomRepo;

    public void addStudentsToClass(Integer classId, List<Integer> studentIds) {
        String joinedIds = studentIds.stream()
                .map(String::valueOf)
                .collect(Collectors.joining(","));
        classroomRepo.addStudentsToClass(classId, joinedIds);
    }

    public List<ClassroomResponse> getStudentsByClass(Integer classId) {
        List<Object[]> rows = classroomRepo.getStudentsByClass(classId);
        return rows.stream()
                .map(r -> new ClassroomResponse(
                        (Integer) r[0],  // StudentId
                        (String) r[1],   // FullName
                        (String) r[2],   // Username
                        (String) r[3],   // Email
                        (Boolean) r[4]   // Enabled
                ))
                .collect(Collectors.toList());
    }

    public List<ClassroomResponse> getAvailableStudents() {
        List<Object[]> rows = classroomRepo.getAvailableStudents();
        return rows.stream()
                .map(r -> new ClassroomResponse(
                        (Integer) r[0],
                        (String) r[1],
                        (String) r[2],
                        (String) r[3],
                        (Boolean) r[4]
                ))
                .collect(Collectors.toList());
    }

    public List<ClassroomSimpleResponse> getAllClassrooms() {
        return StreamSupport.stream(classroomRepo.findAll().spliterator(), false)
                .map(c -> new ClassroomSimpleResponse(c.getId(), c.getClassName()))
                .collect(Collectors.toList());
    }


}
