import { Controller } from "@hotwired/stimulus"

// Connects to data-controller="marks-form"
export default class extends Controller {
  static targets = ["total"];
  
  initialize() {
    this.marks = [];
  }
  
  calculateTotal(event) {
    const fields = Array.from(this.element.querySelectorAll("input[type='number']"));
    const total = fields.reduce((sum, field) => sum + (parseFloat(field.value) || 0), 0);
    this.totalTarget.textContent = total;
    this.marks = fields.map(field => field.value);
  }
  
  sendCalculation() {
    console.log("yo")
    fetch("/points/calc_total", {
      method: "POST",
      headers: { 
        "Content-Type": "application/json",
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']").content
      },
      body: JSON.stringify({ marks: this.marks })
    })
      .then(response => response.json())
      .then(data => {
        this.totalTarget.textContent = data.total; // Assume response contains the total
      });
  }

  disableFields() {
    const fields = Array.from(this.element.querySelectorAll("input[type='number']"));
    fields.forEach(field => field.disabled = true);
  }
}
