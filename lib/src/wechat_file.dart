/*
 * Copyright (c) 2023.  OpenFlutter Project
 *
 *   Licensed to the Apache Software Foundation (ASF) under one or more contributor
 * license agreements.  See the NOTICE file distributed with this work for
 * additional information regarding copyright ownership.  The ASF licenses this
 * file to you under the Apache License, Version 2.0 (the 'License'); you may not
 * use this file except in compliance with the License.  You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an 'AS IS' BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.  See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */
import 'dart:io';
import 'dart:typed_data';

const String defaultSuffixJpeg = '.jpeg';
const String defaultSuffixTxt = '.txt';

class WeChatFile {
  /// [source] must begin with http or https
  WeChatFile.network(
    String this.source, {
    String? suffix,
  })  : assert(source.startsWith('http')),
        schema = FileSchema.network,
        suffix = source.readSuffix(suffix, defaultSuffixTxt);

  ///[source] path of the image, like '/asset/image.pdf?package=flutter',
  ///the query param package in [source] only available when you want to specify the package of image
  WeChatFile.asset(
    String this.source, {
    String? suffix,
  })  : assert(source.trim().isNotEmpty),
        schema = FileSchema.asset,
        suffix = source.readSuffix(suffix, defaultSuffixTxt);

  WeChatFile.file(
    File source, {
    String suffix = defaultSuffixTxt,
  })  : source = source.path,
        schema = FileSchema.file,
        suffix = source.path.readSuffix(suffix, defaultSuffixTxt);

  WeChatFile.binary(
    Uint8List this.source, {
    this.suffix = defaultSuffixTxt,
  })  : assert(suffix.trim().isNotEmpty),
        schema = FileSchema.binary;

  final dynamic source;
  final FileSchema schema;
  final String suffix;

  Map toMap() => {'source': source, 'schema': schema.index, 'suffix': suffix};
}

/// Types of image, usually there are for types listed below.
///
/// [network] is online images.
/// [asset] is flutter asset image.
/// [binary] is binary image, shall be be [Uint8List]
/// [file] is local file, usually not comes from flutter asset.
enum FileSchema { network, asset, file, binary }

extension _FileSuffix on String {
  /// returns [suffix] if [suffix] not blank.
  /// If [suffix] is blank, then try to read from url
  /// if suffix in url not found, then return jpg as default.
  String readSuffix(String? suffix, String defaultSuffix) {
    if (suffix != null && suffix.trim().isNotEmpty) {
      if (suffix.startsWith('.')) {
        return suffix;
      } else {
        return '.$suffix';
      }
    }

    var path = Uri.parse(this).path;
    var index = path.lastIndexOf('.');

    if (index >= 0) {
      return path.substring(index);
    }
    return defaultSuffix;
  }
}
