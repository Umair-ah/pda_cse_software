import { Controller } from "@hotwired/stimulus";

export default class extends Controller {
  static targets = ["container", "dropdown"];

  connect() {
    this.selectedStudentIds = new Set(); // Tracks selected students
    this.maxDropdowns = this.getAvailableStudents().length; // Max number of dropdowns allowed
  }

  filter(event) {
    const selectedValue = event.target.value;

    // Clear all selections from this dropdown in the Set
    this.selectedStudentIds.forEach((id) => {
      if (!this.isValueInAnyDropdown(id)) {
        this.selectedStudentIds.delete(id);
      }
    });

    if (selectedValue) {
      this.selectedStudentIds.add(selectedValue); // Add new selection
    }

    this.updateDropdowns(); // Update all dropdown options
  }

  addDropdown() {
    // if (this.dropdownTargets.length >= this.maxDropdowns) {
    //   alert("You cannot add more.");
    //   return;
    // }

    const container = this.containerTarget;
    const existingDropdown = this.dropdownTargets[0].cloneNode(true);

    // Reset the dropdown value and attach event handlers
    const selectElement = existingDropdown.querySelector("select");
    selectElement.value = "";
    selectElement.addEventListener("change", this.filter.bind(this));

    // Add a remove button
    existingDropdown.querySelector(".remove-dropdown").addEventListener("click", this.removeDropdown.bind(this));

    container.appendChild(existingDropdown);
    this.updateDropdowns();
  }

  removeDropdown(event) {
    const dropdown = event.target.closest(".dropdown");
    const selectElement = dropdown.querySelector("select");
    const selectedValue = selectElement.value;

    if (selectedValue) {
      this.selectedStudentIds.delete(selectedValue); // Remove the selected value
    }

    dropdown.remove();
    this.updateDropdowns(); // Refresh all dropdowns
  }

  updateDropdowns() {
    this.dropdownTargets.forEach((dropdown) => {
      const selectElement = dropdown.querySelector("select");
      const currentValue = selectElement.value;

      // Update options in this dropdown
      const options = selectElement.querySelectorAll("option");
      options.forEach((option) => {
        if (this.selectedStudentIds.has(option.value) && option.value !== currentValue) {
          option.disabled = true;
        } else {
          option.disabled = false;
        }
      });
    });
  }

  isValueInAnyDropdown(value) {
    return Array.from(this.dropdownTargets).some((dropdown) => {
      const selectElement = dropdown.querySelector("select");
      return selectElement.value === value;
    });
  }

  getAvailableStudents() {
    // Fetch available students from the initial Rails dataset
    return JSON.parse(this.element.dataset.students || "[]");
  }
}
