//
//  RecipesController+ParseSwiftLogic.swift
//  DSSRecipes
//
//  Created by David on 22/02/22.
//

import UIKit
import ParseSwift

extension RecipesController {
    /// Retrieves all the recipes stored on your Back4App Database
    @objc func handleReloadRecipes() {
        view.endEditing(true)
        let query = Recipe.query()
        query.find { [weak self] result in // Retrieves all the recipes stored on your Back4App Database and refreshes the UI acordingly
            guard let self = self else { return }
            switch result {
            case .success(let recipes):
                self.recipes = recipes
                self.currentRecipeIndex = recipes.isEmpty ? nil : 0
                self.setupRecipeNavigation()
                
                DispatchQueue.main.async { self.presentCurrentRecipe() }
            case .failure(let error):
                DispatchQueue.main.async { self.showAlert(title: "Error", message: error.message) }
            }
        }
    }
    
    /// Called when the user wants to update the information of the currently displayed recipe
    @objc func handleUpdateRecipe() {
        view.endEditing(true)
        guard let recipe = prepareRecipeMetadata(), recipe.objectId != nil else { // Prepares the Recipe object for updating
            return showAlert(title: "Error", message: "Recipe not found.")
        }
        
        recipe.save { [weak self] result in
            switch result {
            case .success(let newRecipe):
                self?.recipes.append(newRecipe)
                self?.showAlert(title: "Success", message: "Recipe saved on your Back4App Database! (objectId: \(newRecipe.id)")
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failedto save recipe: \(error.message)")
            }
        }
    }
    
    /// Saves the currently displayed recipe on your Back4App Database
    @objc func handleSaveRecipe() {
        view.endEditing(true)
        guard var recipe = prepareRecipeMetadata() else { // Prepares the Recipe object for storing
            return showAlert(title: "Error", message: "Failed to retrieve all the recipe fields.")
        }
        
        recipe.objectId = nil // When saving a Recipe object, we ensure it will be a new instance of it.
        recipe.save { [weak self] result in
            switch result {
            case .success(let newRecipe):
                if let index = self?.currentRecipeIndex { self?.recipes[index] = newRecipe }
                self?.showAlert(title: "Success", message: "Recipe saved on your Back4App Database! (objectId: \(newRecipe.id))")
            case .failure(let error):
                self?.showAlert(title: "Error", message: "Failed to save recipe: \(error.message)")
            }
        }
    }
    
    /// When called it refreshes the UI according to the content of *recipes* and *currentRecipeIndex* properties
    private func presentCurrentRecipe() {
        guard let index = currentRecipeIndex else { return }
        let recipe = recipes[index]
        
        recipeOverviewView.recipe = recipe
        
        for n in (0..<min(ingredientsStackView.arrangedSubviews.count, recipe.ingredients.count)) {
            let textFields = ingredientsStackView.arrangedSubviews[n] as? DoubleTextField
            textFields?.primaryText = "\(recipe.ingredients[n].quantity)"
            textFields?.secondaryText = "\(recipe.ingredients[n].description)"
        }
        
        let infoArray = recipe.nutritionalInfoArray()
        for n in (0..<min(nutritionalInfoStackView.arrangedSubviews.count, infoArray.count)) {
            let textFields = nutritionalInfoStackView.arrangedSubviews[n] as? DoubleTextField
            textFields?.primaryText = infoArray[n].name
            textFields?.secondaryText = infoArray[n].value
        }
    }
    
    /// Adds the 'Next recipe' and 'Previous recipe' button on the navigation bar. These are used to iterate over all the recipes retrieved from your Back4App Database
    private func setupRecipeNavigation() {
        let previousButton = UIBarButtonItem(
            title: "Previous",
            style: .plain,
            target: self,
            action: #selector(handleSwitchRecipe(button:))
        )
        previousButton.tag = PreviousNext.previous.rawValue
        previousButton.tintColor = .white
        
        let nextButton = UIBarButtonItem(
            title: "Next",
            style: .plain,
            target: self,
            action: #selector(handleSwitchRecipe(button:))
        )
        nextButton.tag = PreviousNext.next.rawValue
        nextButton.tintColor = .white
        
        navigationItem.leftBarButtonItem = previousButton
        navigationItem.rightBarButtonItem = nextButton
    }
    
    /// Reads the information the user entered via the from and returns it as a *Recipe* object
    private func prepareRecipeMetadata() -> Recipe? {
        let ingredientsCount = ingredientsStackView.arrangedSubviews.count
        let nutritionalInfoCount = nutritionalInfoStackView.arrangedSubviews.count
        
        let ingredients: [Ingredient] = (0..<ingredientsCount).compactMap { row in
            guard let textFields = ingredientsStackView.arrangedSubviews[row] as? DoubleTextField,
                  let quantityString = textFields.primaryText,
                  let quantity = Float(quantityString),
                  let description = textFields.secondaryText
            else {
                return nil
            }
            return Ingredient(quantity: quantity, description: description)
        }
        
        var nutritionalInfo: [String: String] = [:]
        
        (0..<nutritionalInfoCount).forEach { row in
            guard let textFields = nutritionalInfoStackView.arrangedSubviews[row] as? DoubleTextField,
                  let content = textFields.primaryText, !content.isEmpty,
                  let value = textFields.secondaryText, !value.isEmpty
            else {
                return
            }
            nutritionalInfo[content] = value
        }
        
        let recipeInfo = recipeOverviewView.parseInputToRecipe() // Reads all the remaining fields from the form (name, category, price, serving, etc) and returns them as a tuple
        
        // we collect all the information the user entered and create an instance of Recipe.
        // The recipeInfo.objectId will be nil if the currently displayed information does not correspond to a recipe already saved on your Back4App Database
        let newRecipe: Recipe = Recipe(
            objectId: recipeInfo.objectId,
            name: recipeInfo.name,
            servings: recipeInfo.servings,
            price: recipeInfo.price,
            isAvailable: recipeInfo.isAvailable,
            category: recipeInfo.category,
            ingredients: ingredients,
            sideOptions: recipeInfo.sideOptions,
            nutritionalInfo: nutritionalInfo,
            releaseDate: recipeInfo.releaseDate
        )
        
        return newRecipe
    }
    
    /// Called when the user presses the 'Previous recipe' or 'Next recipe' button
    @objc private func handleSwitchRecipe(button: UIBarButtonItem) {
        guard let option = PreviousNext(rawValue: button.tag), let currentRecipeIndex = currentRecipeIndex else { return }

        let maxIndex = recipes.count
        switch option {
        case .previous: self.currentRecipeIndex = abs(currentRecipeIndex - 1) % maxIndex
        case .next: self.currentRecipeIndex = abs(currentRecipeIndex + 1) % maxIndex
        }
        presentCurrentRecipe()
    }
}
