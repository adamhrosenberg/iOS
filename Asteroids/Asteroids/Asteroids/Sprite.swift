//
//  Sprite.swift
//  Asteroids
//
//  Created by Adam Rosenberg on 4/28/16.
//  Copyright © 2016 Adam Rosenberg. All rights reserved.
//

import GLKit


class Sprite{
    
    //static members
    static private let quad: [Float] = [
        -0.5, -0.5,
        0.5,  -0.5,
        -0.5, 0.5,
        0.5, 0.5,
        ]
    
    static private let quadTextureCoordinates: [Float] = [
        0.0, 1.0,
        1.0,  1.0,
        0.0, 0.0,
        1.0, 0.0,
        ]
    
    static private var _program: GLuint = 0
    
    private static func setup(){
        let vertexShaderSource:NSString = "" +
            "attribute vec2 position;\n" +
            "uniform vec2 translate; \n" +
            "attribute vec2 textureCoordinate; \n" +
            "varying vec2 textureCoordinateInterpolated; \n" +
            "uniform vec2 scale; \n " +
            "uniform vec2 angle; \n " +
            "void main() \n" +
            "{ \n" +
            "    gl_Position = vec4(((position.x*scale.x)+translate.x),((position.y*scale.y)+translate.y),0.0,1.0);\n" +
            "    textureCoordinateInterpolated = vec2(textureCoordinate.x, textureCoordinate.y); \n" +
            "} \n" +
            " \n" +
        " \n"
        
        let fragmentShaderSource:NSString = "" +
            "uniform highp vec4 color; \n" +
            "uniform sampler2D textureUnit; \n" +
            "varying highp vec2 textureCoordinateInterpolated; \n" +
            "void main() \n" +
            "{ \n" +
            "    gl_FragColor = texture2D(textureUnit, textureCoordinateInterpolated); \n" +
            "} \n" +
            " \n" +
        " \n"
        
        //vertex shader
        let vertexShader: GLuint = glCreateShader(GLenum(GL_VERTEX_SHADER))
        var vertexShaderSourceUTF8 = vertexShaderSource.UTF8String
        glShaderSource(vertexShader, 1, &vertexShaderSourceUTF8, nil)
        glCompileShader(vertexShader) //compiles and stores the .exe
        //check result of compiling
        //allocate a variable to fill in with mem for unafe ptr
        var verxterShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(vertexShader, GLenum(GL_COMPILE_STATUS), &verxterShaderCompileStatus)
        
        if(verxterShaderCompileStatus == GL_FALSE){
            var vertexShaderLogLength: GLint = 0
            glGetShaderiv(vertexShader, GLenum(GL_INFO_LOG_LENGTH), &vertexShaderLogLength)
            let vertexShaderLog = UnsafeMutablePointer<GLchar>.alloc(Int(vertexShaderLogLength))
            glGetShaderInfoLog(vertexShader, vertexShaderLogLength, nil, vertexShaderLog)
            let vertexShaderLogString: NSString? = NSString(UTF8String: vertexShaderLog)
            print("shader Compile failed! \(vertexShaderLogString)")
            //todo prevent drawing
        }
        
        
        //fragment shader
        let fragmentShader: GLuint = glCreateShader(GLenum(GL_FRAGMENT_SHADER))
        var fragmentShaderSourceUTF8 = fragmentShaderSource.UTF8String
        glShaderSource(fragmentShader, 1, &fragmentShaderSourceUTF8, nil)
        glCompileShader(fragmentShader) //compiles and stores the .exe
        //check result of compiling
        //allocate a variable to fill in with mem for unafe ptr
        var fragmentShaderCompileStatus: GLint = GL_FALSE
        glGetShaderiv(fragmentShader, GLenum(GL_COMPILE_STATUS), &fragmentShaderCompileStatus)
        
        if(fragmentShaderCompileStatus == GL_FALSE){
            var fragmentShaderLogLength: GLint = 0
            glGetShaderiv(fragmentShader, GLenum(GL_INFO_LOG_LENGTH), &fragmentShaderLogLength)
            let fragmentShaderLog = UnsafeMutablePointer<GLchar>.alloc(Int(fragmentShaderLogLength))
            glGetShaderInfoLog(fragmentShader, fragmentShaderLogLength, nil, fragmentShaderLog)
            let fragmentShaderLogString: NSString? = NSString(UTF8String: fragmentShaderLog)
            print("frag Compile failed! \(fragmentShaderLogString)")
            //todo prevent drawing
        }
        
        
        //link shaders to program
        _program = glCreateProgram()
        glAttachShader(_program, vertexShader)
        glAttachShader(_program, fragmentShader)
        glBindAttribLocation(_program, 0, "position")
        glBindAttribLocation(_program, 1, "textureCoordinate")
        glLinkProgram(_program)
        var programLinkStatus : GLint = GL_FALSE
        glGetProgramiv(_program, GLenum(GL_LINK_STATUS), &programLinkStatus)
        
        if(programLinkStatus == GL_FALSE){
            var programLogLength: GLint = 0
            glGetProgramiv(_program, GLenum(GL_INFO_LOG_LENGTH), &programLogLength)
            let programLinkLog = UnsafeMutablePointer<GLchar>.alloc(Int(programLogLength))
            glGetProgramInfoLog(_program, programLogLength, nil, programLinkLog)
            let programLogString: NSString? = NSString(UTF8String: programLinkLog)
            print("Link failed! \(programLogString)")
        }
        
        
        glEnable(GLenum(GL_BLEND))
        glBlendFunc(GLenum(GL_SRC_ALPHA), GLenum(GL_ONE_MINUS_SRC_ALPHA))
        glUseProgram(_program)
        glEnableVertexAttribArray(0)
        glVertexAttribPointer(0, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, quad)
        
        glEnableVertexAttribArray(1)
        glVertexAttribPointer(1, 2, GLenum(GL_FLOAT), GLboolean(GL_FALSE), 0, quadTextureCoordinates)
        
    }
    
    
    
    /*
     ////////////////////////////////////////////////////////////////////////////////////////////////
     ////////////////////////////////////////////////////////////////////////////////////////////////
     ///////////////////////////////////////   NON STATIC BELOW   ///////////////////////////////////
     ////////////////////////////////////////////////////////////////////////////////////////////////
     *///////////////////////////////////////////////////////////////////////////////////////////////
    
    
    
    //non static memebers
    var position: Vector = Vector()
    var width: Float = 1.0
    var height: Float = 1.0
    var angleX: Float = 0.0 //cos(0) = 1
    var angleY: Float = 90.0 //sin(90) = 1
    var texture: GLuint = 0
    var name:String = ""
    var id:NSUUID = NSUUID()
    var invaderMove:String = ""
    
    func draw(){
        
        if(Sprite._program == 0){
            Sprite.setup()
        }
        glUniform2f(glGetUniformLocation(Sprite._program, "translate"), position.x, position.y)
        glUniform2f(glGetUniformLocation(Sprite._program, "scale"), width, height)
        glUniform2f(glGetUniformLocation(Sprite._program, "angle"), angleX, angleY)
        glUniform1i(glGetUniformLocation(Sprite._program, "textureUnit"), 0)
        glBindTexture(GLenum(GL_TEXTURE_2D), texture)
        glDrawArrays(GLenum(GL_TRIANGLE_STRIP), 0, 4)
    }
    
    
}
