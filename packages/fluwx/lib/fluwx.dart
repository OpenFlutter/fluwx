/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 * Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

/// Fluwx is a powerful plugin for WeChatSDK.
/// easy to use.
///
///  A open sou;rce project authorized by [OpenFlutter](https://github.com/OpenFlutter).
library fluwx;

export 'src/fluwx.dart';
export 'src/foundation/arguments.dart';
export 'src/foundation/cancelable.dart' hide FluwxCancelableImpl;
export 'src/response/wechat_response.dart';
export 'src/wechat_enums.dart';
export 'src/wechat_file.dart' hide FileSchema;
