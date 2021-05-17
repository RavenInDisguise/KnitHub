/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA;

import java.util.List;
import java.util.Optional;
import javax.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author monic
 */
@Service
@Transactional
public class KnitHubService {
    @Autowired
    private IKnitHubRepository repoPattern;
    
    public void GenerarPatron(Patterns pattern){
        repoPattern.GenerarPatron(pattern.getMacaddress(),pattern.getUserName(),pattern.getLastName(),pattern.getPatternName(),pattern.getCategoryName(),pattern.getDescription());
    }
    public void GenerarProyecto(Projects project){
        //System.out.println(project.getMacaddress()+""+project.getUserName()+""+project.getLastName()+""+project.getPatternName()+""+project.getProjectName());
        repoPattern.GenerarProyecto(project.getMacaddress(),project.getUserName(),project.getLastName(),project.getPatternName(),project.getProjectName());
    }
    
    /* 
    public List<Patterns> listSalePatterns(){
        return repo.PatronesEnVenta();
    } 
    */
}

