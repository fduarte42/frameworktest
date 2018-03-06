<?php
/**
 * Created by PhpStorm.
 * User: tito.duarte
 * Date: 06.03.2018
 * Time: 13:07
 */

namespace Application\Service;


use Application\View\Renderer\CustomPhpRenderer;
use Interop\Container\ContainerInterface;
use Zend\Mvc\Service\ViewPhpRendererFactory;
use Zend\ServiceManager\ServiceLocatorInterface;

class CustomViewPhpRendererFactory extends ViewPhpRendererFactory
{
    public function __invoke(ContainerInterface $container, $name, array $options = null)
    {
        $renderer = new CustomPhpRenderer();
        $renderer->setHelperPluginManager($container->get('ViewHelperManager'));
        $renderer->setResolver($container->get('ViewResolver'));

        return $renderer;
    }

    public function createService(ServiceLocatorInterface $container)
    {
        return $this($container, CustomPhpRenderer::class);
    }
}