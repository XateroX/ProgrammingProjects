float rand(float value, float border){
  return random((value-border),(value+border));
}
float vectorDist(PVector v1, PVector v2){
  vecDist = sqrt( ( pow( ( v1.x-v2.x ) ,2) ) + ( pow( ( v1.y-v2.y ) ,2) ) );
  return vecDist;
}

float vectorMag(PVector v){
  vecMag = sqrt( ( pow( (v.x) ,2) ) + ( pow( (v.y) ,2) ) );
  return vecMag;
}

//v1 = starting position, v2 = final position
PVector unitDirVector(PVector v1, PVector v2){
  resultVec.x = (v2.x-v1.x);
  resultVec.y = (v2.y-v1.y);
  vecMag = vectorMag( resultVec );
  unitVec.x = (1 / vecMag)*( resultVec.x );
  unitVec.y = (1 / vecMag)*( resultVec.y );
  return unitVec;
}
