#!/usr/bin/env perl6
use Test;
use nqp;
constant $crnl = False;
sub chrs (Mu \listy) {
    my $list     := nqp::decont(listy);
    my int $i     = -1;
    my int $elems = nqp::elems($list);
    my $result   := nqp::list_s;
    nqp::setelems($result,$elems);

    my $value;
    nqp::while(nqp::islt_i(++$i,$elems), (
      $value := nqp::atpos($list,$i);
      nqp::bindpos_s($result,$i,nqp::chr($value));
      )
    );
      

    nqp::join("",$result)
}
sub ords (Mu $str) {
  my $NFC := nqp::strtocodes($str, nqp::const::NORMALIZE_NFC, nqp::create(NFC));
  my $blah := nqp::list_i;
  my int $n = nqp::elems($NFC);
  loop (my int $i = 0; $i < $n; $i = $i + 1) {
      nqp::push_i($blah, nqp::atpos_i($NFC, $i));
  }
  $blah;
}
sub shift-it ($amount) {
  
}
#my $orig-string = "한국어/조선말";
my $orig-string = Q:to/END/;
‘결혼 빙하기’라 불릴 정도로 결혼을 꺼리거나 아예 포기하는 미혼 남녀가 늘고 있다. 지난해엔
역대 최저치의 혼인율을 기록하기도 한 것. 오픈서베이가 최근 발표한 ‘결혼에 관한 리포트’에 따르면,
결혼이 늦어지는 가장 큰 이유로 ‘결혼 비용 증가(62%)’, '늦은 취업(56%)’ 등 현실적인 문제가
꼽혔다. 또 기혼 미혼 관계없이 10명 중 3명은 경제적 이유로 결혼을 연기한 경험이 있었다.
하지만 20·30세대 미혼 남녀 10명 중 8명은 ‘경제적 부담’과 같은 현실적 어려움에도 불구하고,
향후 5년 내 결혼할 의향이 있다고 답했다. 사랑하는 사람과 평생을 함께하고 싶고(76%), 심리적
안정을 얻고 싶기 때문(60%)이다. 그래서 결혼을 생각하는 요즘 커플들에겐 비용을 줄이면서도 진정
두 사람이 주인공이 되는 스마트하고 합리적인 결혼 준비가 필수다. 천편일률적인 결혼식, 고비용
‘스드메’를 개선하는 ‘스몰웨딩’, ‘셀프웨딩’이 새로운 트렌드가 된 이유도 바로 여기 있다.
물론 또 다른 벽이 나타날 수 있다. 막상 거품을 뺀 우리만의 작은 결혼식을 결심해도 부모님과
갈등이 생기거나 때론 일반 예식보다 더 큰 비용이 발생하는 등 고민거리가 이어지기 때문. 어떻게
하면 좀 더 스마트하게 결혼 준비를 할 수 있을까. 그럼 지금부터 남다른 소비 방식으로 우리만의
특별한 결혼식을 준비하는 팁을 알아볼까.
END
$orig-string ~~ s:g/\n/\r\n/ if $crnl;
my $ords := ords($orig-string);
my int $i = 1;
while $i <= nqp::elems($ords) {
  my $o := nqp::clone($ords);
  my $n := nqp::splice($o, nqp::list_i, 0, $i);
  my $concatted := nqp::concat(chrs($n), chrs($o));
  ok nqp::iseq_s($concatted, $orig-string);
  ok nqp::chars($concatted) == nqp::chars($orig-string);
  $i++;
}
done-testing;