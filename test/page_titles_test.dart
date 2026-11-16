import 'package:flutter_test/flutter_test.dart';
import 'package:jv_alma_cis/routing/page_titles.dart';

void main() {
  test('home title names the company and what it does', () {
    expect(pageTitleFor('/'), homeTitle);
    expect(homeTitle, startsWith('JV ALMA C.I.S'));
  });

  test('other pages read "<page> | JV ALMA C.I.S"', () {
    expect(pageTitleFor('/about'), 'About Us | JV ALMA C.I.S');
    expect(pageTitleFor('/oil-gas'), 'Oil & Gas Services | JV ALMA C.I.S');
    expect(pageTitleFor('/it-division'), 'IT Division | JV ALMA C.I.S');
  });

  test('unknown routes are labelled as not found', () {
    expect(pageTitleFor('/nope'), 'Page not found | JV ALMA C.I.S');
  });
}
