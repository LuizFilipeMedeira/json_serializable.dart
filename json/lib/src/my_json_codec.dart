// ignore_for_file: slash_for_doc_comments

import 'dart_convert_exports.dart';
import 'decoder/my_json_decoder.dart';
import 'encoder/my_json_encoder.dart';

const json = const MyJsonCodec();

/**
 * A [MyJsonCodec] encodes JSON objects to strings and decodes strings to
 * JSON objects.
 *
 * Examples:
 *
 *     var encoded = json.encode([1, 2, { "a": null }]);
 *     var decoded = json.decode('["foo", { "bar": 499 }]');
 */
class MyJsonCodec extends Codec<Object, String> {
  final ToEncodable _toEncodable;

  /**
   * Creates a `JsonCodec` with the given reviver and encoding function.
   *
   * The [toEncodable] function is used during encoding. It is invoked for
   * values that are not directly encodable to a string (a value that is not a
   * number, boolean, string, null, list or a map with string keys). The
   * function must return an object that is directly encodable. The elements of
   * a returned list and values of a returned map do not need to be directly
   * encodable, and if they aren't, `toEncodable` will be used on them as well.
   * Please notice that it is possible to cause an infinite recursive regress
   * in this way, by effectively creating an infinite data structure through
   * repeated call to `toEncodable`.
   *
   * If [toEncodable] is omitted, it defaults to a function that returns the
   * result of calling `.toJson()` on the unencodable object.
   */
  const MyJsonCodec({toEncodable(Object object)}) : _toEncodable = toEncodable;

  /**
   * Parses the string and returns the resulting Json object.
   */
  @override
  dynamic decode(String source) => decoder.convert(source);

  /**
   * Converts [value] to a JSON string.
   *
   * If value contains objects that are not directly encodable to a JSON
   * string (a value that is not a number, boolean, string, null, list or a map
   * with string keys), the [toEncodable] function is used to convert it to an
   * object that must be directly encodable.
   *
   * If [toEncodable] is omitted, it defaults to a function that returns the
   * result of calling `.toJson()` on the unencodable object.
   */
  @override
  String encode(Object value, {toEncodable(object)}) {
    if (toEncodable == null) toEncodable = _toEncodable;
    if (toEncodable == null) return encoder.convert(value);
    return new JsonEncoder(toEncodable).convert(value);
  }

  @override
  JsonEncoder get encoder {
    if (_toEncodable == null) return const JsonEncoder();
    return new JsonEncoder(_toEncodable);
  }

  @override
  MyJsonDecoder get decoder => const MyJsonDecoder();
}