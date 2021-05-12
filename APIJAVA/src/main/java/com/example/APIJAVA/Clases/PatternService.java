/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.example.APIJAVA.Clases;

import java.util.List;
import javax.transaction.Transactional;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

/**
 *
 * @author monic
 */
@Service
@Transactional
public class PatternService {
    @Autowired
    private IPatternRepository repo;
    
    public List<Pattern> listAll(){
        return repo.findAll();
    }
    
    public void save(Pattern pattern){
        repo.save(pattern);
    }
    
     public Pattern get(String macaddress) {
        return repo.findById(macaddress).get();
    }
    
    public void delete(String macaddress){
        repo.deleteById(macaddress);
    }
}

