/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA;

import java.util.List;
import java.util.Optional;
import javax.transaction.Transactional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

/**
 *
 * @author monic
 */
@Repository
public interface IKnitHubRepository extends JpaRepository<Patterns,String>{
    
    @Transactional
    @Modifying
    @Query(value ="{call GenerarPatron(:pMacAddress, :pName, :pLastName, :pPatternName, :pPatternCategoryName, :pPatternDescription)}",nativeQuery = true)
    void GenerarPatron(
            @Param("pMacAddress")String pMacAddress,
            @Param("pName")String pName,
            @Param("pLastName")String pLastName,
            @Param("pPatternName")String pPatternName,
            @Param("pPatternCategoryName")String pPatternCategoryName,
            @Param("pPatternDescription")String pPatternDescription
    );
    
    @Transactional
    @Modifying
    @Query(value ="{call GenerarProyecto(:pMacAddress, :pName, :pLastName, :pPatternName, :pProjectName)}",nativeQuery = true)
    void GenerarProyecto(
            @Param("pMacAddress")String pMacAddress,
            @Param("pName")String pName,
            @Param("pLastName")String pLastName,
            @Param("pPatternName")String pPatternName,
            @Param("pProjectName")String pProjectName
    );
    
    /*
    @Query(value ="{call PatronesEnVenta()}",nativeQuery = true)
    List<Patterns> PatronesEnVenta();
    */
} 
