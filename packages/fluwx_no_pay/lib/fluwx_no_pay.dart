/*
 * Copyright (c) 2023. OpenFlutter Project
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements. The ASF licenses this file to you under the Apache
 * License, Version 2.0 (the "License"); you may not use this file except in
 * compliance with the License. You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 */

/// Fluwx no-pay variant.
///
/// This package exposes the same Dart API as `fluwx`, while the iOS native
/// package links the no-payment WeChat SDK.
library fluwx_no_pay;

export 'src/fluwx.dart';
export 'src/foundation/arguments.dart';
export 'src/foundation/cancelable.dart' hide FluwxCancelableImpl;
export 'src/response/wechat_response.dart';
export 'src/wechat_enums.dart';
export 'src/wechat_file.dart' hide FileSchema;
