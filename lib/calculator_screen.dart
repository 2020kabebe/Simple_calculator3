import 'package:flutter/material.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({Key? key}) : super(key: key);

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _output = '0';
  String _input = '';
  double _num1 = 0;
  String _operand = '';

  void _buttonPressed(String buttonText) {
    setState(() {
      if (buttonText == 'C') {
        _output = '0';
        _input = '';
        _num1 = 0;
        _operand = '';
      } else if (buttonText == 'DEL') {
        if (_input.isNotEmpty) {
          _input = _input.substring(0, _input.length - 1);
          if (_input.isEmpty) {
            _output = '0';
          } else {
            _output = _input;
          }
        }
      } else if (buttonText == '+' || buttonText == '-' || buttonText == 'x' || buttonText == '/') {
        if (_input.isNotEmpty) {
          _num1 = double.parse(_input);
          _operand = buttonText;
          _input = '';
          _output = '0';
        }
      } else if (buttonText == '=') {
        if (_input.isNotEmpty && _operand.isNotEmpty) {
          double num2 = double.parse(_input);
          switch (_operand) {
            case '+':
              _output = (_num1 + num2).toString();
              break;
            case '-':
              _output = (_num1 - num2).toString();
              break;
            case 'x':
              _output = (_num1 * num2).toString();
              break;
            case '/':
              _output = (_num1 / num2).toString();
              break;
          }
          _num1 = double.parse(_output);
          _operand = '';
          _input = _output;
        }
      } else {
        if (_input == '0') {
          _input = buttonText;
        } else {
          _input += buttonText;
        }
        _output = _input;
      }
    });
  }

  Widget _buildButton(String buttonText, {Color color = Colors.white, Color textColor = Colors.black}) {
    return Expanded(
      child: ElevatedButton(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all(color),
          foregroundColor: WidgetStateProperty.all(textColor),
          padding: WidgetStateProperty.all(const EdgeInsets.all(24.0)),
        ),
        onPressed: () => _buttonPressed(buttonText),
        child: Text(
          buttonText,
          style: const TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Container(
          alignment: Alignment.centerRight,
          padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 12.0),
          child: Text(
            _output,
            style: const TextStyle(
              fontSize: 48.0,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        const Expanded(child: Divider()),
        Column(
          children: [
            Row(
              children: [
                _buildButton('7'),
                _buildButton('8'),
                _buildButton('9'),
                _buildButton('/', color: Colors.orange, textColor: Colors.white),
              ],
            ),
            Row(
              children: [
                _buildButton('4'),
                _buildButton('5'),
                _buildButton('6'),
                _buildButton('x', color: Colors.orange, textColor: Colors.white),
              ],
            ),
            Row(
              children: [
                _buildButton('1'),
                _buildButton('2'),
                _buildButton('3'),
                _buildButton('-', color: Colors.orange, textColor: Colors.white),
              ],
            ),
            Row(
              children: [
                _buildButton('0'),
                _buildButton('C', color: Colors.red, textColor: Colors.white),
                _buildButton('=', color: Colors.green, textColor: Colors.white),
                _buildButton('+', color: Colors.orange, textColor: Colors.white),
              ],
            ),
            Row(
              children: [
                _buildButton('DEL', color: Colors.grey, textColor: Colors.white),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
