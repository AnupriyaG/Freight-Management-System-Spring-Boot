package edu.njit.fms.db.repository;

import org.springframework.data.repository.CrudRepository;

import edu.njit.fms.db.entity.CustomProject;

public interface CustomProjectRepository
        extends CrudRepository<CustomProject, Long> {
    
}