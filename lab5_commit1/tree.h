#pragma once
#ifndef TREE_H
#define TREE_H
#include<iostream>
#include<vector>
#include<string>
using namespace std;

enum NodeType{
    NODE_BOOL,
    NODE_VAR,
    NODE_EXRP,
    NODE_TYPE,
    NODE_STMT,
    NODE_PROG,
    NODE_OP,
    NODE_FUNC,
    NODE_CINT,
    NODE_CCHAR,
    NODE_CSTR,
    NODE_STRUCT
};

enum StmtType{
    STMT_IF,
    STMT_WHILE,
    STMT_FOR,
    STMT_DECL,
    STMT_ASSIGN,
    STMT_PRINTF,
    STMT_SCANF
};

enum VarFlag
{
    VAR_COMMON,
    VAR_REFERENCE,
    VAR_POINTER
};

enum OpType{
    OP_ADD, OP_MINUS, OP_MUL, OP_DIV, OP_MOD,
    OP_NOT, OP_AND, OP_OR, OP_AS,
    OP_LS, OP_GT, OP_EQ, OP_LE, OP_GE, OP_NE,
    OP_ADDTO, OP_MINTO, OP_MULTO, OP_DIVTO, OP_MODTO,
    OP_DADD, OP_DMIN
};

enum VarType{
    VAR_INTEGER,
    VAR_VOID,
    VAR_CHAR,
    VAR_STRING
};
static int NodeIndex = 0;
class TreeNode
{
public:
    TreeNode(int NodeType);
    void addChild(TreeNode *Child);
    void addSibling(TreeNode *Sibling);
    void genNodeId();
    void printAST();
    TreeNode* getChild(int index);
    int childNum();

    vector<TreeNode *> dim;
    int nodeType, nodeIndex;
    int opType, stmtType;
    int varType, int_val, varFlag;
    char char_val;
    bool bool_val;
    string str_val;
    string varName;
private:
    vector<TreeNode *> CHILDREN;
    vector<TreeNode *> SIBLING;
};
#endif