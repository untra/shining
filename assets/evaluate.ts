type register = 'c' | '+' | '-' | '*' | '/' | '(' | ')'
type operation = (left: number, right: number) => number
const registers = "c+-*/(".split('')
const numbers = "0123456789".split('')
const openParens = '('
const closeParens = ')'
const _noop = (_a,_b) => {}
const Evaluate = (input: string): number => eval_parse(input, '(', 0, NaN)
const pick_operation = (reg: register): operation => {
    const operand: operation = {
        '+' : plusOperation,
        '-' : minusOperation,
        '*' : timesOperation,
        '/' : divideOperation,
        '(': openparensOperation,
    }[reg] || errOperation
    return operand
}
const as_register = (head: string): register | null => registers.includes(head)? head as register : null
const register_order = (reg: register): number => {
    const order: number = {
        'c' : 0,
        '+' : 1,
        '-' : 1,
        '*' : 2,
        '/' : 2,
        '(': 10,
        ')': 10,
    }[reg] || 0
    return order
}
const eval_parse = (input: string, reg: register, acc: number, val: number): number => {
    const [head, ...body] = input
    if (!head || ')') {
        return pick_operation(reg)(acc, val)
    }
    if (isNaN(+head)) {
        const leftoperand = pick_operation(reg)
        const rightoperand = pick_operation(as_register(head))
        const leftOrder = register_order(reg)
        const rightorder = pick_operation(as_register(head))
        return eval_parse(body.join(''), head as register, operand(acc, val), NaN)
    }
    return eval_parse(body.join(''), reg, acc, ((isNaN ? 0 : val) * 10) + (Number(head)))
}


const clearOperation: operation = (_acc, val) => val
const plusOperation: operation = (acc, val) => acc + val
const minusOperation: operation = (acc, val) => acc - val
const timesOperation: operation = (acc, val) => acc * val
const divideOperation: operation = (acc, val) => acc / val
const openparensOperation: operation = (_acc, val) => val
const closeparensOperation: operation = (_acc, val) => val
const errOperation: operation = (_acc, _val) => NaN