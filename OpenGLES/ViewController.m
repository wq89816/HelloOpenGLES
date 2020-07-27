//
//  ViewController.m
//  OpenGLES
//
//  Created by zhangchi on 7/26/20.
//  Copyright © 2020 Wangqiao. All rights reserved.
//

#import "ViewController.h"
@interface ViewController(){
    EAGLContext *context;
    GLKBaseEffect *cEffect;
    int _angle;
}
@end

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //1.相关初始化
    [self setUpConfig];

    //2.加载顶点/纹理坐标
    [self setUpVertexData];

    //3.加载纹理
    [self setUpTexture];
}

-(void)setUpConfig
{
    //初始化上下文
    context = [[EAGLContext alloc]initWithAPI:kEAGLRenderingAPIOpenGLES3];
    if(!context){
        NSLog(@"创新ES上下文失败");
    }
    [EAGLContext setCurrentContext:context];

    //获取GLKView,设置contex
    GLKView *view = (GLKView *)self.view;
    view.context = context;

    //配置视图创建的渲染缓存区.
    view.drawableColorFormat = GLKViewDrawableColorFormatRGBA8888;
    view.drawableDepthFormat = GLKViewDrawableDepthFormat24;
    view.drawableStencilFormat = GLKViewDrawableStencilFormatNone;

    //设置背景颜色
    glClearColor(1, 1.0, 1.0, 1.0);


}
-(void)setUpVertexData
{
        //设置顶点数组(顶点坐标,纹理坐标)
    GLfloat vertexData[] = {


        //背面
        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        0.5, 0.5,  0.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上

        0.5, -0.5, 0.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 0.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 0.0f,   0.0f, 0.0f, //左下

        //正面
        0.5, -0.5, 1.0f,    1.0f, 0.0f, //右下
        0.5, 0.5,  1.0f,    1.0f, 1.0f, //右上
        -0.5, 0.5, 1.0f,    0.0f, 1.0f, //左上

        0.5, -0.5, 1.0f,    1.0f, 0.0f, //右下
        -0.5, 0.5, 1.0f,    0.0f, 1.0f, //左上
        -0.5, -0.5, 1.0f,   0.0f, 0.0f, //左下

        //右面
        0.5f, -0.5f, 0.0f,    1.0f, 0.0f, //右下
        0.5f, 0.5f,  0.0f,    1.0f, 1.0f, //右上
        0.5f, 0.5f, 1.0f,    0.0f, 1.0f, //左上

        0.5f, -0.5f, 0.0f,    1.0f, 0.0f, //右下
        0.5f, 0.5f, 1.0f,    0.0f, 1.0f, //左上
        0.5f, -0.5f, 1.0f,   0.0f, 0.0f, //左下

            //左面
        -0.5f, -0.5f, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, 0.5f,  0.0f,    1.0f, 1.0f, //右上
        -0.5f, 0.5f, 1.0f,    0.0f, 1.0f, //左上

        -0.5f, -0.5f, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, 0.5f, 1.0f,    0.0f, 1.0f, //左上
        -0.5f, -0.5f, 1.0f,   0.0f, 0.0f, //左下


        //底面
        0.5f, -0.5f, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, -0.5f,  0.0f,    1.0f, 1.0f, //右上
        -0.5f, -0.5f, 1.0f,    0.0f, 1.0f, //左上

        0.5f, -0.5f, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, -0.5f, 1.0f,    0.0f, 1.0f, //左上
        0.5f, -0.5f, 1.0f,   0.0f, 0.0f, //左下

        //顶面
        0.5f, 0.5f, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, 0.5f,  0.0f,    1.0f, 1.0f, //右上
        -0.5f, 0.5f, 1.0f,    0.0f, 1.0f, //左上

        0.5f, 0.5f, 0.0f,    1.0f, 0.0f, //右下
        -0.5f, 0.5f, 1.0f,    0.0f, 1.0f, //左上
        0.5f, 0.5f, 1.0f,   0.0f, 0.0f, //左下

    };

    //创建顶点缓存区标识符ID
    GLuint bufferID;
    glGenBuffers(1, &bufferID);

    //绑定顶点缓存区
    glBindBuffer(GL_ARRAY_BUFFER, bufferID);

    //将顶点数组的数据从内存copy到顶点缓存区(显存)中
    glBufferData(GL_ARRAY_BUFFER, sizeof(vertexData), vertexData, GL_STATIC_DRAW);

    //打开读取通道
    /*
     glVertexAttribPointer (GLuint indx, GLint size, GLenum type, GLboolean normalized, GLsizei stride, const GLvoid* ptr)

     功能: 上传顶点数据到显存的方法（设置合适的方式从buffer里面读取数据）
     参数列表:
     index,指定要修改的顶点属性的索引值,例如
     size, 每次读取数量。（如position是由3个（x,y,z）组成，而颜色是4个（r,g,b,a）,纹理则是2个.）
     type,指定数组中每个组件的数据类型。可用的符号常量有GL_BYTE, GL_UNSIGNED_BYTE, GL_SHORT,GL_UNSIGNED_SHORT, GL_FIXED, 和 GL_FLOAT，初始值为GL_FLOAT。
     normalized,指定当被访问时，固定点数据值是否应该被归一化（GL_TRUE）或者直接转换为固定点值（GL_FALSE）
     stride,指定连续顶点属性之间的偏移量。如果为0，那么顶点属性会被理解为：它们是紧密排列在一起的。初始值为0
     ptr指定一个指针，指向数组中第一个顶点属性的第一个组件。初始值为0
     */
    //顶点坐标
    glEnableVertexAttribArray(GLKVertexAttribPosition);
    glVertexAttribPointer(GLKVertexAttribPosition, 3, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT)*5, (GLfloat *)NULL);

    //纹理坐标
    glEnableVertexAttribArray(GLKVertexAttribTexCoord0);
    glVertexAttribPointer(GLKVertexAttribTexCoord0, 2, GL_FLOAT, GL_FALSE, sizeof(GL_FLOAT)*5, (GLfloat *)NULL+3);

}
-(void)setUpTexture
{

    //获取纹理图片路径
    NSString *filePath = [[NSBundle mainBundle]pathForResource:@"meimei" ofType:@"jpg"];

    //设置纹理参数
    //纹理坐标原点是左下角,但是图片显示原点应该是左上角.
    NSDictionary *options = [NSDictionary dictionaryWithObjectsAndKeys:@(1),GLKTextureLoaderOriginBottomLeft, nil];
    GLKTextureInfo *info = [GLKTextureLoader textureWithContentsOfFile:filePath options:options error:nil];

    //使用苹果GLKit 提供GLKBaseEffect 完成着色器工作(顶点/片元)
    cEffect = [[GLKBaseEffect alloc]init];
    cEffect.texture2d0.enabled = GL_TRUE;
    cEffect.texture2d0.name = info.name;

        // 3D 透视投影矩阵
    CGFloat aspect = fabs(self.view.bounds.size.width / self.view.bounds.size.height);
    GLKMatrix4 projectionMatrix = GLKMatrix4MakePerspective(GLKMathDegreesToRadians(45.0), aspect, 0.1, 100.0);
    cEffect.transform.projectionMatrix = projectionMatrix;

}
#pragma mark -- GLKViewDelegate
- (void)glkView:(GLKView *)view drawInRect:(CGRect)rect
{
   //清空颜色缓存区
    glClear(GL_COLOR_BUFFER_BIT | GL_STENCIL_BUFFER_BIT | GL_DEPTH_BUFFER_BIT);
    //开启深度测试
    glEnable(GL_DEPTH_TEST);

    //准备绘制
      [self update];
    [cEffect prepareToDraw];

    //开始绘制 两个三角形
    /*
     BeginMode 图元组成模式
#define GL_POINTS                                        0x0000
#define GL_LINES                                         0x0001
#define GL_LINE_LOOP                                     0x0002
#define GL_LINE_STRIP                                    0x0003
#define GL_TRIANGLES                                     0x0004
#define GL_TRIANGLE_STRIP                                0x0005
#define GL_TRIANGLE_FAN                                  0x0006
     */
    glDrawArrays(GL_TRIANGLES, 0, 48);
}
- (void)update {
    _angle = (_angle + 2) % 360;
    GLKMatrix4 modelviewMatrix = GLKMatrix4Translate(GLKMatrix4Identity, 0, 0, -4.0);
    modelviewMatrix = GLKMatrix4Rotate(modelviewMatrix, GLKMathDegreesToRadians(_angle), 0.3, 0.5, 0.7);
    cEffect.transform.modelviewMatrix = modelviewMatrix;
}

@end
