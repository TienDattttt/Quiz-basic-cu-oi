package com.microshop.backend.repository;

import com.microshop.backend.entity.ClassroomStudent;
import com.microshop.backend.entity.ClassroomStudentId;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

public interface ClassroomStudentRepository extends JpaRepository<ClassroomStudent, ClassroomStudentId> {
    List<ClassroomStudent> findByStudent_Id(Integer studentId);
}
