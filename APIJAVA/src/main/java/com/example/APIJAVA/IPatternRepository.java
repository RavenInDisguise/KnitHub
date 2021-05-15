/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA;

import java.util.List;
import java.util.Optional;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

/**
 *
 * @author monic
 */
@Repository
public interface IPatternRepository extends JpaRepository<Patterns,String>{
    
    @Query(value ="{call PatronesEnVenta()}",nativeQuery = true)
    List<Patterns> PatronesEnVenta();
    
   /* Optional<Patterns> CompraPatrones(String macaddres,String userName, 
                                      String lastName, String patternName,
                                      String categoryName, String materialName);

*/
}