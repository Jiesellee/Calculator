function add(a, b) {
  return a + b;
}

function multiply(a, b) {
  return a * b;
}

function subtract(a, b) {
  return a - b;
}

function divide(a, b) {
  return a / b;
}

function operate(operation, num1, num2) {
  return operation(num1, num2);
}

module.exports = { add, multiply, subtract, divide };
