<?php

/*
 * This file is part of the DunglasApiBundle package.
 *
 * (c) Kévin Dunglas <dunglas@gmail.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

namespace Dunglas\ApiBundle\Hydra\EventListener;

use Dunglas\ApiBundle\Api\UrlGeneratorInterface;
use Dunglas\ApiBundle\JsonLd\ContextBuilder;
use Symfony\Component\HttpKernel\Event\FilterResponseEvent;

/**
 * Adds the HTTP Link header pointing to the Hydra documentation.
 *
 * @author Kévin Dunglas <dunglas@gmail.com>
 */
final class LinkHeaderResponseListener
{
    /**
     * @var UrlGeneratorInterface
     */
    private $urlGenerator;

    public function __construct(UrlGeneratorInterface $urlGenerator)
    {
        $this->urlGenerator = $urlGenerator;
    }

    /**
     * Sends the Hydra header on each response.
     *
     * @param FilterResponseEvent $event
     */
    public function onKernelResponse(FilterResponseEvent $event)
    {
        $event->getResponse()->headers->set('Link', sprintf(
            '<%s>; rel="%sapiDocumentation"',
            $this->urlGenerator->generate('api_hydra_vocab', [], UrlGeneratorInterface::ABS_URL), ContextBuilder::HYDRA_NS)
        );
    }
}
