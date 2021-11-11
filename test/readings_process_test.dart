import 'package:rh_collector/domain/states/recognizer.dart';
import 'package:test/test.dart';

main() {
  Recognizer t = Recognizer();
  test("cleanup reading", () async {
    expect(t.cleanString("m 01 "), "01");
    expect(t.cleanString("m 02 h"), "02");
    expect(t.cleanString("h  dsad 3, hh"), "3");
    expect(t.cleanString("m :124, "), "124");
    expect(t.cleanString("m :12 40 56, "), "124056");
  });
}
