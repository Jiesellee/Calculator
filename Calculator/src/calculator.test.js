const {add,multiply,subtract,divide} = require('./calculator');

describe('check calulations provide right sums',()=>{
    it('sums two numbers together', () => {
       expect(add(1,3)).toBe(4);
    });
    it('mulitplies two numbers together',()=>{
        expect(multiply(2,2)).toBe(4);
        expect(multiply(0,8)).toBe(0);
    });

    it ('subtracts the second number from the first',()=>{
        expect(subtract(149,39)).toBe(110);
        expect(subtract(20,29)).toBe(-9);
        expect(subtract(-3,3)).toBe(-6);
    });
    it('divides two numbers by each other',()=>{
        expect(divide(4,2)).toBe(2);
        expect(divide(2,4)).toBe(0.5);
        expect(divide(-2,4)).toBe(-0.5);
    });


})

 
