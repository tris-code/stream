/*
 * Copyright 2017 Tris Foundation and the project authors
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License
 *
 * See LICENSE.txt in the project root for license information
 * See CONTRIBUTORS.txt for the list of the project authors
 */

public enum SeekOrigin {
    case begin, current, end
}

protocol Seekable {
    func seek(to offset: Int, from origin: SeekOrigin) throws
}
