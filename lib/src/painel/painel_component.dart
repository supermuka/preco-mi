// Copyright (c) 2015, Google Inc. Please see the AUTHORS file for details.
// All rights reserved. Use of this source code is governed by a BSD-style
// license that can be found in the LICENSE file.


import 'package:angular/angular.dart';
import 'package:angular_components/angular_components.dart';

import 'package:chartjs/chartjs.dart';

@Component(
    selector: 'precomi-painel',
    providers: const <dynamic>[materialProviders],
    directives: const [
      CORE_DIRECTIVES,
      DeferredContentDirective,
      ScoreboardComponent,
      ScorecardComponent,
    ],
    templateUrl: 'painel_component.html',
    styleUrls: const [
      'painel_component.css'
    ])

class PainelComponent implements OnInit {
  @override
  ngOnInit() async {

  }


}