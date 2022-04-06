#pragma arguments

vec4 overlay(vec4 a, vec4 b)
{
  vec4 x = vec4(2.0) * a * b;
  vec4 y = vec4(1.0) - vec4(2.0) * (vec4(1.0)-a) * (vec4(1.0)-b);
  vec4 result;
  result.r = mix(x.r, y.r, float(a.r > 0.5));
  result.g = mix(x.g, y.g, float(a.g > 0.5));
  result.b = mix(x.b, y.b, float(a.b > 0.5));
  result.a = mix(x.a, y.a, float(a.a > 0.5));
  return result;
}

float skin_mask(in vec4 color)
{
  vec3 lab = rgb2lab(color.rgb); # return values in the range [0, 1]
  float a = smoothstep(0.45, 0.55, lab.g);
  float b = smoothstep(0.46, 0.54, lab.b);
  float c = 1.0 — smoothstep(0.9, 1.0, length(lab.gb));
  float d = 1.0 — smoothstep(0.98, 1.02, lab.r);
  return min(min(min(a, b), c), d);
}

for each pixel m in image:
  result = 0
  for each neighbour pixel n:
    weight = spatial_filter(spacial_distance(m, n))
    weight *= range_filter(range_distance(image(m), image(n)))
    total_weight += weight
    result += weight * image(n)
  filtered_image(m) = result / total_weight


for each slab l in range(0, K):
  slab_range = l / (K - 1)
  for each pixel m in image:
    weights(m) = range_filter(range_distance(image(m), slab_range))
  blurred_slabs[l] = gaussian_blur(image * weights) / weights
combine_slabs(blurred_slabs, image)
