#include<string>
#include<vector>
using namespace std;
class variable
{
public:
    int type;
    string name;
    int int_val;
    string str_val;
    int index;
    variable()
    {
        this->type = 0;
        this->name = "";
        this->index = 0;                                                                                                                                                             ;
    }
    variable(int type, string name, int i)
    {
        this->type = type;
        this->name = name;
        this->index = i;
    }
};
class scope
{
public:
    vector<variable> varies;
    int sindex;
    void output()
    {
        for(int i = 0;i < varies.size();i++)
        {
            printf("%s  %d\n", varies[i].name.c_str(), sindex);
        }
    }
    scope(vector<variable> varies, int sindex)
    {
        this->varies = varies;
        this->sindex = sindex;
    }
};
