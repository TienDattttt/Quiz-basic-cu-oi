package com.microshop.backend.repository;

import com.microshop.backend.entity.Classroom;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.jpa.repository.query.Procedure;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface ClassroomRepository extends CrudRepository<com.microshop.backend.entity.Classroom, Integer> {

    @Procedure(procedureName = "sp_AddStudentsToClass")
    void addStudentsToClass(@Param("ClassId") Integer classId, @Param("StudentIds") String studentIds);
    @Query(value = "EXEC sp_GetStudentsByClass :ClassId", nativeQuery = true)
    List<Object[]> getStudentsByClass(@Param("ClassId") Integer classId);

    @Query(value = "EXEC sp_GetAvailableStudents", nativeQuery = true)
    List<Object[]> getAvailableStudents();

    List<Classroom> findByTeacher_Id(Integer teacherId);

}
