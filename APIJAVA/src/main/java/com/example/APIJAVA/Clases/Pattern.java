/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
 
package com.example.APIJAVA.Clases;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;

/**
 *
 * @author monic
 */
@Entity
public class Pattern {
    
    private String macaddress;
    private String userName;
    private String lastName;
    private String patternName;
    private String categoryName;
    private String materialName;
    
    public Pattern(){
    }

    public Pattern(String macaddress, String userName, String lastName, String patternName, String categoryName, String materialName) {
        this.macaddress = macaddress;
        this.userName = userName;
        this.lastName = lastName;
        this.patternName = patternName;
        this.categoryName = categoryName;
        this.materialName = materialName;
    }
    
    @Id
    @GeneratedValue(strategy=GenerationType.IDENTITY)
    public String getMacaddress(){
        return macaddress/**/;
    }  
    
    public void setMacaddress(String macaddress) {
        this.macaddress = macaddress;
    }

    public String getUserName() {
        return userName;
    }

    public void setUserName(String userName) {
        this.userName = userName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPatternName() {
        return patternName;
    }

    public void setPatternName(String patternName) {
        this.patternName = patternName;
    }

    public String getCategoryName() {
        return categoryName;
    }

    public void setCategoryName(String categoryName) {
        this.categoryName = categoryName;
    }

    public String getMaterialName() {
        return materialName;
    }

    public void setMaterialName(String materialName) {
        this.materialName = materialName;
    }
    
}
