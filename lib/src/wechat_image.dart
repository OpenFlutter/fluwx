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
import 'dart:io';
import 'dart:typed_data';

///[suffix] shall be started with .
class WeChatImage {
  final dynamic source;
  final ImageSchema schema;
  final String suffix;

  WeChatImage.network(String source, {String suffix})
      : assert(source != null && source.startsWith("http")),
        this.source = source,
        this.schema = ImageSchema.NETWORK,
        this.suffix = source.readSuffix(suffix);

  WeChatImage.asset(String source, {String suffix})
      : assert(source != null && source.trim().isNotEmpty),
        this.source = source,
        this.schema = ImageSchema.ASSET,
        this.suffix = source.readSuffix(suffix);

  WeChatImage.file(File source, {String suffix = ".jpeg"})
      : assert(source != null),
        this.source = source.path,
        this.schema = ImageSchema.FILE,
        this.suffix = source.path.readSuffix(suffix);

  WeChatImage.binary(Uint8List source, {String suffix = ".jpeg"})
      : assert(source != null),
        assert(suffix != null && suffix.trim().isNotEmpty),
        this.source = source,
        this.schema = ImageSchema.BINARY,
        this.suffix = suffix;

  Map toMap() => {"source": source, "schema": schema.index, "suffix": suffix};
}

///Types of image, usually there are for types listed below.
///[ImageSchema.NETWORK] is online images.
///[ImageSchema.ASSET] is flutter asset image.
///[ImageSchema.BINARY] is binary image, shall be be [Uint8List]
///[ImageSchema.FILE] is local file, usually not comes from flutter asset.
enum ImageSchema {
  NETWORK,
  ASSET,
  FILE,
  BINARY,
}

extension _ImageSuffix on String {
  /// returns [suffix] if [suffix] not blank.
  /// If [suffix] is blank, then try to read from url
  /// if suffix in url not found, then return jpg as default.
  String readSuffix(String suffix) {
    if (suffix != null && suffix.trim().isNotEmpty) return suffix;

    var path = Uri.parse(this).path;
    var index = path.lastIndexOf(".");

    if (index >= 0) {
      return path.substring(index);
    }
    return ".jpeg";
  }
}
