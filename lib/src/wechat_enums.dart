/*
 * Copyright (c) 2020.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
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

///[WXMiniProgramType.RELEASE]正式版
///[WXMiniProgramType.TEST]测试版
///[WXMiniProgramType.PREVIEW]预览版
enum WXMiniProgramType { RELEASE, TEST, PREVIEW }

///[WeChatScene.SESSION]会话
///[WeChatScene.TIMELINE]朋友圈
///[WeChatScene.FAVORITE]收藏
enum WeChatScene { SESSION, TIMELINE, FAVORITE }

extension MiniProgramTypeExtensions on WXMiniProgramType {
  int toNativeInt() {
    switch (this) {
      case WXMiniProgramType.PREVIEW:
        return 2;
      case WXMiniProgramType.TEST:
        return 1;
      case WXMiniProgramType.RELEASE:
        return 0;
    }
    return 0;
  }
}
