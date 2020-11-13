import 'package:check_it_off/helpers/validator.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Empty Task Name', () {
    var result = FieldValidator.validateLength('');
    expect(result, 'Task must have a name.');
  });

}