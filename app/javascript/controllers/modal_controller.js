import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="modal"
export default class extends Controller {
  static targets = ["modal"];

  show(event) {
    const modalId = event.target.getAttribute("data-modal-target");
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.remove("hidden");
      modal.classList.add("flex");
    }
  }

  hide(event) {
    const modalId = event.target.getAttribute("data-modal-target");
    const modal = document.getElementById(modalId);
    if (modal) {
      modal.classList.add("hidden");
      modal.classList.remove("flex");
    }
  }

  toggleProjectType(event) {
    const existingProjectDropdown = document.getElementById("existing_project_dropdown");
    const newProjectField = document.getElementById("new_project_field");
  
    // Clear the fields when switching options
    if (event.target.value === "existing") {
      // Clear new project field
      const newProjectInput = newProjectField.querySelector("input");
      if (newProjectInput) {
        newProjectInput.value = "";
      }
  
      // Show existing project dropdown and hide new project field
      existingProjectDropdown.classList.remove("hidden");
      newProjectField.classList.add("hidden");
    } else if (event.target.value === "new") {
      // Clear existing project dropdown
      const existingProjectSelect = existingProjectDropdown.querySelector("select");
      if (existingProjectSelect) {
        existingProjectSelect.value = "";
      }
  
      // Show new project field and hide existing project dropdown
      newProjectField.classList.remove("hidden");
      existingProjectDropdown.classList.add("hidden");
    }
  }
  

  toggleRadioButton(event){
    const existingProjectRadioButton = document.getElementById("existing_project_type_radio");
    const existingProjectDropdown = document.getElementById("existing_project_dropdown");


    if(event.target.value == "Mini"){
      existingProjectRadioButton.classList.remove("hidden");
      fetch(`/projects/fetch_by_program?program_name=Mini`)
      .then(response => response.json())
      .then(data => {
        this.populateDropdown(data);
      })
      .catch(error => console.error("Error fetching projects:", error));
      
    } else if(event.target.value == "Major"){
      existingProjectRadioButton.classList.remove("hidden");
      fetch(`/projects/fetch_by_program?program_name=Major`)
      .then(response => response.json())
      .then(data => {
        this.populateDropdown(data);
      })
      .catch(error => console.error("Error fetching projects:", error));

    }
  }

  populateDropdown(projects) {
    // Parent element where the dropdown will be placed
    const dropdownContainer = document.getElementById("existing_project_dropdown");
  
    // Clear any existing content inside the dropdown container
    dropdownContainer.innerHTML = "";
  
    // Create the select element
    const selectElement = document.createElement("select");
    selectElement.id = "dynamic_project_dropdown"; // Assign an ID for easy access if needed
    selectElement.name = "existing_project_id"; // Set the name attribute for form submission
    selectElement.className = "form-select w-full border border-gray-300 rounded-lg p-2 shadow-lg";
  
    // Create and append the placeholder option
    const placeholderOption = document.createElement("option");
    placeholderOption.value = "";
    placeholderOption.textContent = "Select a Project";
    selectElement.appendChild(placeholderOption);
  
    // Create and append the project options
    projects.forEach(project => {
      const option = document.createElement("option");
      option.value = project.id;
      option.textContent = project.title;
      selectElement.appendChild(option);
    });
  
    // Append the dynamically created select element to the container
    dropdownContainer.appendChild(selectElement);
  }
  
}
