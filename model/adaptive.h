
#include <vector>

struct hx {
public:
  double hx2[2];
  std::vector<double> hx_;
  hx() : hx_(2){};
  void reset();
  void save(double a);
  double current();
  double previous();
};

void hx::reset() {
 hx_[0] = 0;
 hx_[1] = 0;
}

void hx::save(double a) {
 hx_[1] = hx_[0];
 hx_[0] = a;
}

double hx::current() {
  return hx_[0];
}

double hx::previous() {
  return hx_[1]; 
}

double hx::adjust(double F1) {
  if(resp > 118 && resp < 122) return F1;
  if(resp > 122 && resp < 150) return F1 * 0.8;
  if(resp > 150) return F1 * 0.6;
  if(resp > 105 && resp < 118) return F1 * 1.3;
  if(resp < 105) return F1 * 2;
  return F1;
}


