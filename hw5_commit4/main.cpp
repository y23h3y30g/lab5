#include"main.tab.hh"
#include"common.h"
#include<iostream>
using std::cout;
using std::endl;
TreeNode *root=nullptr;
vector<scope> scopes;
vector<variable> curscope;
vector<struct_def> strdef;
vector<variable> strscope;
int sindex = 0;
int rbrace_n = 0;
int cur_sindex=0;
string str_name[10];
int name_num=0; 
int main ()
{
    yyparse();
    if(root){//若存在语法树结点
        root->genNodeId();//将整棵语法树赋予id
        root->printAST();//打印相关信息
    }
}
int yyerror(char const* message)
{
  cout << message << endl;
  return -1;
}