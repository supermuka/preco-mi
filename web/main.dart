// Copyright (c) 2017, Administrador. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.


import 'package:angular/angular.dart';
import 'package:preco_mi/app_component.dart';
import 'package:http/browser_client.dart';

void main() {
  bootstrap(AppComponent, [
      provide(BrowserClient, useFactory: () => new BrowserClient(), deps: [])]);
}
