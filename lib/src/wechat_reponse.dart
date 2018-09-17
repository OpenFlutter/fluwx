/*
 * Copyright (C) 2018 The OpenFlutter Organization
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
class WeChatResponseCode {
  static const int ERR_OK = 0;
  static const int ERR_COMM = -1;
  static const int ERR_USER_CANCEL = -2;
  static const int ERR_SENT_FAILED = -3;
  static const int ERR_AUTH_DENIED = -4;
  static const int ERR_UNSUPPORTED = -5;
  static const int ERR_BAN = -6;
}

class WeChatResponseKey {
  static const String TYPE = "type";
  static const String ERR_CODE = "errCode";
  static const String ERR_STR = "errStr";
  static const String TRANSACTION = "transaction";
  static const String OPEN_ID = "openId";
}
